--Basic Monster Effect Template
local s,id=GetID()
function s.initial_effect(c)
    --Add your effects here
    
    --Example: Cannot be destroyed by battle
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e1:SetValue(1)
    c:RegisterEffect(e1)
end
