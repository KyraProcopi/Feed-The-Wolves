using { /Fortnite.com/AI }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Animation/PlayAnimation}
using { /Verse.org/Assets }
using { /Fortnite.com/Devices }
using { /Verse.org }
using { /Verse.org/Colors }
using { /Verse.org/Random }
using { /Verse.org/Simulation }
using { /Verse.org/Simulation/Tags }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
 
# A Verse-authored NPC Behavior that can be used within an NPC Character Definition or an NPC Spawner device's NPC Behavior Script Override.
wolf_main := class(npc_behavior):

    MeatManage : meat_manager = meat_manager{}
    var Eat1 : animation_sequence = wolf_eat_fbx_01_Anim
    var PlayerList : []player = array{}

    # How long to wait in seconds after the NPC navigates to a point before moving on.
    @editable_number(float):
        MinValue:=option{5.0},
        MaxValue:=option{15.0}
    MoveToWaitDuration:float = 5.0

    # The negative min and absolute max x & y coordinate offset in centimeters to tell the NPC to move to
    @editable_number(float):
        MinValue:=option{0.0}
    DistanceFromSpawnPtToMove:float = 2500.0

    #Global Variables
    var NavList:[] navigation_target = array{}

    GetNewPoint(NPCSpawnPoint: vector3)<suspends> :void =
        # Create a random offset from the spawn point to walk toward.
        GoToPoint := NPCSpawnPoint + vector3{X := GetRandomFloat(-DistanceFromSpawnPtToMove,DistanceFromSpawnPtToMove),
        Y := GetRandomFloat(-DistanceFromSpawnPtToMove,DistanceFromSpawnPtToMove),
        Z := 0.0 }

        # Create a navigation target from these two positions that the navigation interface can use.
        NavTargetStart := MakeNavigationTarget(GoToPoint)
        NavTargetEnd := MakeNavigationTarget(NPCSpawnPoint)

        set NavList = array{NavTargetStart, NavTargetEnd}


    # This function runs when the NPC is spawned in the world and ready to follow a behavior.
    OnBegin<override>()<suspends>:void =

        if:
            # Get the Agent (the NPC).
            Agent := GetAgent[]
            Character := Agent.GetFortCharacter[]
            Navigatable := Character.GetNavigatable[]
            Focus := Character.GetFocusInterface[]
            NPCAnim := Character.GetPlayAnimationController[]

        then:
            NPCSpawnPoint := Character.GetTransform().Translation
            GetNewPoint(NPCSpawnPoint)
            var Index: int = 1
            
            loop:
                loop:
                    if(MeatManage.ConditionalB.IsHoldingItem[PlayerList[0]]):
                        set MeatManage.boolisMeatDropped = 0
                        break
                            
                    if (not MeatManage.ConditionalB.IsHoldingItem[PlayerList[0]]):    
                        #GetPlayerPosition()
                        set MeatManage.boolisMeatDropped = 1
                        break

                loop:
                    MeatManage.GetIsMeatDropped()
                    if (not MeatManage.ConditionalB.IsHoldingItem[PlayerList[0]]):
                        Sleep(0.1)
                        if(not Character.IsActive[]):
                            break

                        if(NewTarget := MeatManage.FindNearestTarget[Character], NewAgent := NewTarget.GetAgent[]):
                            spawn{Focus.MaintainFocus(NewAgent)}
                            #Focus.MaintainFocus(NewAgent)
                            NavTarget := MakeNavigationTarget(NewAgent)
                            Navigatable.NavigateTo(NavTarget , ?MovementType := movement_types.Running, ?ReachRadius := 450.0)
                            NPCAnim.Play(Eat1)
                            Sleep(5.0)
                            break

                    #if (MeatManage.ConditionalB.IsHoldingItem[MeatManage.PlayerList[0]]):         
                        if (NavTargetCurrent := NavList[0]):
                            set Index = 1-Index
                            if(Index=1):
                                GetNewPoint(NPCSpawnPoint) 
                
                                NavResultGoTo := Navigatable.NavigateTo(NavTargetCurrent, ?MovementType:=movement_types.Walking)
                                Navigatable.Wait(?Duration := MoveToWaitDuration)
                                break
    

    # This function runs when the NPC is despawned or eliminated from the world.
    OnEnd<override>():void =
        return
