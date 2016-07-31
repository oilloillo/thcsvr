--暗✿之拜访
function c10072.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c10072.target)
	e1:SetOperation(c10072.activate)
	c:RegisterEffect(e1)
end
function c10072.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x110) 
end
function c10072.filter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c10072.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c10072.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10072.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(c10072.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
	local TargetNum = Duel.IsExistingMatchingCard(c10072.cfilter,tp,LOCATION_MZONE,0,1,nil) and 2 or 1
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c10072.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,TargetNum,nil)
	-- if Duel.IsExistingMatchingCard(c10072.cfilter,tp,LOCATION_MZONE,0,1,nil) then
		-- Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		-- local g=Duel.SelectTarget(tp,c10072.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,2,nil)
	-- else
		-- Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		-- local g=Duel.SelectTarget(tp,c10072.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	-- end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c10072.chfilter(c,e)
	return c:IsFaceup() and c:IsRelateToEffect(e)
end
function c10072.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(c10072.chfilter,nil,e)
	if tg:GetCount()>0 then
		Duel.ChangePosition(tg,POS_FACEDOWN_ATTACK,0,POS_FACEDOWN_DEFENCE,0)
	end
end
