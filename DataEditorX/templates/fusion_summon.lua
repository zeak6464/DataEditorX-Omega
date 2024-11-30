--Fusion Summon Template
local s,id=GetID()
function s.initial_effect(c)
    --Fusion material
    c:EnableReviveLimit()
    Fusion.AddProcMix(c,true,true,CARD_ID_1,CARD_ID_2) --Replace CARD_ID_1 and CARD_ID_2 with required materials
    
    --Optional: Fusion summon procedure
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_HAND)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
end

function s.filter1(c,e)
    return c:IsOnField() and not c:IsImmuneToEffect(e)
end

function s.filter2(c,e,tp,m,f)
    return c:IsType(TYPE_FUSION) and (not f or f(c))
        and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
        and c:CheckFusionMaterial(m,nil,tp)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local mg1=Duel.GetFusionMaterial(tp)
        local res=Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil)
        return res
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
    local mg1=Duel.GetFusionMaterial(tp):Filter(s.filter1,nil,e)
    local sg1=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil)
    if #sg1>0 then
        local tc=sg1:Select(tp,1,1,nil):GetFirst()
        Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
        tc:CompleteProcedure()
    end
end
