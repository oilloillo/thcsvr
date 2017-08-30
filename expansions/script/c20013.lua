 
--莉莉霍瓦特
function c20013.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x208),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--sp summon success
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(20013,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c20013.con)
	e1:SetCost(c20013.cost)
	e1:SetTarget(c20013.tg)
	e1:SetOperation(c20013.op)
	c:RegisterEffect(e1)
end
function c20013.filter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c20013.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c20013.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,20013)==0 end
	Duel.RegisterFlagEffect(tp,20013,RESET_PHASE+PHASE_END,0,1)
end
function c20013.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c20013.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c20013.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c20013.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
