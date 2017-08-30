 
--秘封「广重36号」
function c28035.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28035,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c28035.target)
	e2:SetOperation(c28035.operation)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(28035,1))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetCondition(c28035.drcon)
	e3:SetCost(c28035.drcost)
	e3:SetTarget(c28035.drtg)
	e3:SetOperation(c28035.drop)
	c:RegisterEffect(e3)
end
function c28035.filter(c)
	return c:IsSetCard(0x211) and c:IsAbleToDeck()
end
function c28035.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(c28035.filter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	e:GetHandler():RegisterFlagEffect(28035,RESET_PHASE+PHASE_END,0,1)
end
function c28035.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetMatchingGroup(c28035.filter,p,LOCATION_HAND,0,nil)
	if g:GetCount()<1 then
		local hg=Duel.GetFieldGroup(p,LOCATION_HAND,0)
		Duel.ConfirmCards(1-p,hg)
		Duel.ShuffleHand(p)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(p,1,1,nil)
		Duel.ConfirmCards(1-p,sg)
		Duel.SendtoDeck(sg,nil,1,REASON_EFFECT)
		Duel.ShuffleDeck(p)
		Duel.BreakEffect()
		Duel.Draw(p,1,REASON_EFFECT)
	end
end
function c28035.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c28035.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c28035.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(28035)>=1 and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c28035.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
