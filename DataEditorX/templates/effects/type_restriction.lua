--Type Restriction Effect Template (Similar to "Rivalry of Warlords")
local s,id=GetID()
function s.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    
    --Send to grave immediately
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_ADJUST)
    e2:SetRange(LOCATION_SZONE)
    e2:SetOperation(s.adjustop)
    c:RegisterEffect(e2)
    
    --Cannot summon other types
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetTargetRange(1,1)
    e3:SetTarget(s.sumlimit)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_CANNOT_SUMMON)
    c:RegisterEffect(e4)
    local e5=e3:Clone()
    e4:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
    c:RegisterEffect(e5)
end

--Adjust operation for sending monsters of different types to grave
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
    local phase=Duel.GetCurrentPhase()
    if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    if #g==0 then return end
    local sg=Group.CreateGroup()
    local typemap={}
    local p=0
    local tc=g:GetFirst()
    while tc do
        local typ=tc:GetRace()
        if not typemap[p] then
            typemap[p]=typ
        elseif typemap[p]~=typ then
            --Different type exists
            local g1=Duel.GetMatchingGroup(Card.IsFaceup,p,LOCATION_MZONE,0,nil)
            if #g1>0 then
                Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(id,0))
                local rg=g1:Select(p,1,1,nil)
                local typ2=rg:GetFirst():GetRace()
                typemap[p]=typ2
                local g2=g1:Filter(s.typfilter,nil,typ2)
                sg:Merge(g2)
            end
        end
        tc=g:GetNext()
        if not tc then
            if p==0 then
                p=1
                tc=g:GetFirst()
            end
        end
    end
    if #sg>0 then
        Duel.SendtoGrave(sg,REASON_RULE)
        Duel.Readjust()
    end
end

function s.typfilter(c,typ)
    return c:GetRace()~=typ
end

--Summon limit check
function s.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
    if sumpos and (sumpos&POS_FACEDOWN)>0 then return false end
    local tp=sump
    if targetp then tp=targetp end
    return Duel.IsExistingMatchingCard(s.typefilter,tp,LOCATION_MZONE,0,1,c)
end

function s.typefilter(c)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
