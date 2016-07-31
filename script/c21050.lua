 
--燕之子安贝 -永命线-
function c21050.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c21050.condition)
	e1:SetTarget(c21050.target)
	e1:SetOperation(c21050.activate)
	c:RegisterEffect(e1)
end
function c21050.cfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x161)
end
function c21050.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c21050.cfilter1,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil)
end
function c21050.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c21050.filter(c)
	return c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c21050.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	local hg=Duel.GetMatchingGroup(c21050.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	if hg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(21050,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local toh=hg:Select(tp,1,1,nil)
		Duel.HintSelection(toh)
		Duel.BreakEffect()
		Duel.SendtoHand(toh,nil,REASON_EFFECT)
	end
end
