--废狱的火车✿火焰猫燐
function c24071.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x208),1)
	c:EnableReviveLimit()
	--stg
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(24071,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c24071.scost)
	e1:SetTarget(c24071.stg)
	e1:SetOperation(c24071.sop)
	c:RegisterEffect(e1)
	--redirect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_BATTLE_DESTROY_REDIRECT)
	e2:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e2)
end
function c24071.sfilter(c)
	return c:IsSetCard(0x625) and c:IsType(TYPE_MONSTER) and c:GetLevel()==1 and c:IsAbleToRemoveAsCost()
end
function c24071.scost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c1=Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,2,nil)
	local c2=Duel.IsExistingMatchingCard(c24071.sfilter,tp,LOCATION_GRAVE,0,2,nil)
	if chk==0 then return c1 or c2 end
	local opt=2
	if c1 then opt=0 end
	if c2 then opt=1 end
	if c1 and c2 then opt=Duel.SelectOption(tp,aux.Stringid(24071,1),aux.Stringid(24071,2)) end
	if opt==0 then Duel.DiscardHand(tp,Card.IsDiscardable,2,2,REASON_COST+REASON_DISCARD)
		else
			local sg=Duel.SelectMatchingCard(tp,c24071.sfilter,tp,LOCATION_GRAVE,0,2,2,nil)
			Duel.Remove(sg,POS_FACEUP,REASON_COST)
		end
end
function c24071.stg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c24071.sop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then Duel.SendtoGrave(tc,REASON_EFFECT) end
end