--Multiple Attacks Effect Template
local s,id=GetID()
function s.initial_effect(c)
    --Attack twice
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_EXTRA_ATTACK)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    
    --Attack all monsters
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_ATTACK_ALL)
    e2:SetValue(s.atkfilter)
    c:RegisterEffect(e2)
end

function s.atkfilter(e,c)
    return c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
