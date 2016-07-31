 
--夜王「德古拉摇篮」
function c22109.initial_effect(c)
	c:EnableCounterPermit(0x28c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c22109.ctcon)
	e2:SetOperation(c22109.ctop)
	c:RegisterEffect(e2)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetDescription(aux.Stringid(22109,0))
	e4:SetCountLimit(1)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCost(c22109.cost)
	e4:SetTarget(c22109.drtg)
	e4:SetOperation(c22109.drop)
	c:RegisterEffect(e4)
end
function c22109.ctfilter(c)
	return (c:IsSetCard(0x813) or c:GetOriginalCode()==(22100) or c:GetOriginalCode()==(22117))
end
function c22109.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22109.ctfilter,1,nil)
end
function c22109.ctop(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(c22109.ctfilter,nil)
	e:GetHandler():AddCounter(0x28c,ct)
end
function c22109.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x28c,2,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.RemoveCounter(tp,1,1,0x28c,2,REASON_COST)
end
function c22109.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,0,0,tp,1)
end
function c22109.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
