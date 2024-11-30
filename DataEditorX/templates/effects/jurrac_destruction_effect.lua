--Jurrac Destruction Effect Template (similar to Jurrac Stigo/Volcano effects)
local s,id=GetID()
function s.initial_effect(c)
    --Destroy to send and Special Summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTarget(s.destg)
    e1:SetOperation(s.desop)
    c:RegisterEffect(e1)
end
function s.tgfilter(c)
    return c:IsRace(RACE_DINOSAUR) and c:IsAbleToGrave()
end
function s.spfilter(c,e,tp,lv)
    return c:IsSetCard(0x22) and c:IsLevel(lv) and c:IsCanBeSpecialSummon(e,0,tp,false,false)
        and not c:IsCode(id)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,0,1,nil)
        and Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil) end
    local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,0,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
    --Cannot Special Summon except Dinosaurs
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
    e1:SetTargetRange(1,0)
    e1:SetTarget(s.splimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
    --Effect implementation
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,0,1,1,nil)
    if #g>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local tg=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
        if #tg>0 and Duel.SendtoGrave(tg,REASON_EFFECT)~=0 then
            local tc=tg:GetFirst()
            local lv=tc:GetLevel()
            local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
            if ft<=0 then return end
            local sg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp,lv)
            if #sg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
                Duel.BreakEffect()
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
                local spg=sg:Select(tp,1,ft,nil)
                if #spg>0 then
                    Duel.SpecialSummon(spg,0,tp,tp,false,false,POS_FACEUP)
                end
            end
        end
    end
end
function s.splimit(e,c)
    return not c:IsRace(RACE_DINOSAUR)
end
