--Lock Effects Template
local s,id=GetID()
function s.initial_effect(c)
    --Cannot activate effects
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_ACTIVATE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(0,1)
    e1:SetValue(s.aclimit)
    c:RegisterEffect(e1)
    
    --Cannot Special Summon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(0,1)
    e2:SetTarget(s.sumlimit)
    c:RegisterEffect(e2)
    
    --Cannot add cards
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CANNOT_TO_HAND)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(0,LOCATION_DECK)
    c:RegisterEffect(e3)
    
    --Skip phases
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetCode(EFFECT_SKIP_BP)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(0,1)
    c:RegisterEffect(e4)
end

function s.aclimit(e,re,tp)
    return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end

function s.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
    return c:IsType(TYPE_SYNCHRO)
end
