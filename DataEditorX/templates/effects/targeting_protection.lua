--Targeting Protection Effect Template
local s,id=GetID()
function s.initial_effect(c)
    --Cannot be targeted
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e1:SetValue(aux.tgoval)
    c:RegisterEffect(e1)
    
    --Protect other cards from targeting
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(s.tgtg)
    e2:SetValue(aux.tgoval)
    c:RegisterEffect(e2)
    
    --Conditional targeting protection
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e3:SetCondition(s.tgcon)
    e3:SetValue(s.tgval)
    c:RegisterEffect(e3)
end

function s.tgtg(e,c)
    return c:IsType(TYPE_MONSTER) and c~=e:GetHandler()
end

function s.tgcon(e)
    return Duel.IsExistingMatchingCard(Card.IsType,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler(),TYPE_SYNCHRO)
end

function s.tgval(e,re,rp)
    return rp~=e:GetHandlerPlayer()
end
