 
--艾哲红石
function c21055.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c21055.target)
	e1:SetOperation(c21055.activate)
	c:RegisterEffect(e1)
end
function c21055.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c21055.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x208)
end
function c21055.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	local hg=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_SZONE,nil)
	if hg:GetCount()>0 and Duel.IsExistingMatchingCard(c21055.filter,tp,0,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(21055,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
		local toh=hg:Select(tp,1,1,nil)
		Duel.HintSelection(toh)
		Duel.BreakEffect()
		Duel.ConfirmCards(tp,toh)
	end
end
