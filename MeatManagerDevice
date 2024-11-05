using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Fortnite.com/Characters }
using { /UnrealEngine.com/Temporary/SpatialMath }


meat_manager := class(creative_device):

    @editable ConditionalB:conditional_button_device = conditional_button_device{}   
    
    var PlayerList : []player = array{}
    var boolisMeatDropped : int = 0;
    
    GetPlayerPosition(): void =
        if (FortCharacter := PlayerList[0].GetFortCharacter[] ):
            PlayerPosition : vector3 = FortCharacter.GetTransform().Translation   
            Print("X = {PlayerPosition.X} Y ={PlayerPosition.Y} Z = {PlayerPosition.Z}")  

    GetIsMeatDropped(): int = boolisMeatDropped

    # FIND PLAYER         
    FindNearestTarget(FC : fort_character)<decides><transacts> : fort_character = 
        var MaybeTarget : ?fort_character = false
        var CheckRange : float = 1250.0
        for(Player : GetPlayspace().GetPlayers(), PlayerFC := Player.GetFortCharacter[]):
            if:
                DistanceDifference := Distance(PlayerFC.GetTransform().Translation, FC.GetTransform().Translation) < CheckRange
                not PlayerFC = FC
            then:
                set MaybeTarget = option{PlayerFC}
                set CheckRange = DistanceDifference   
        
        return MaybeTarget?
            
    OnBegin<override>()<suspends>:void=
        Print("We have started") 
        set PlayerList = GetPlayspace().GetPlayers()
            
        loop:
            if(ConditionalB.IsHoldingItem[PlayerList[0]]):
                set boolisMeatDropped = 0
                break
                    
            if (not ConditionalB.IsHoldingItem[PlayerList[0]]):    
                #GetPlayerPosition()
                set boolisMeatDropped = 1
                break
        
