--丧心「丧心疮痍」
function c7001200.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_TOHAND)
	e1:SetCategory(CATEGORY_HANDES)
	e1:SetCost(c7001200.cost)
	e1:SetTarget(c7001200.target)
	e1:SetOperation(c7001200.operation)
	c:RegisterEffect(e1)
end
function c7001200.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c7001200.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
		and Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,564)
	local ac=Duel.AnnounceCard(tp)
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD)
end
function c7001200.operation(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,0,LOCATION_HAND,nil,ac)
	local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	Duel.ConfirmCards(tp,hg)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		Duel.ShuffleHand(1-tp)
	else
		local sg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		Duel.ConfirmCards(1-tp,sg)
		Duel.Hint(HINT_MESSAGE,1-tp,HINTMSG_REMOVE)
		local dg=sg:Select(1-tp,1,1,nil)
		Duel.Remove(dg,POS_FACEDOWN,REASON_EFFECT)
		Duel.ShuffleHand(tp)
	end
end
