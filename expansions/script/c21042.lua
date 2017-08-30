 
--”¿“π∑µ
function c21042.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c21042.condition)
	e1:SetTarget(c21042.target)
	e1:SetOperation(c21042.activate)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21042,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c21042.drcon)
	e2:SetTarget(c21042.drtg)
	e2:SetOperation(c21042.drop)
	c:RegisterEffect(e2)
end
function c21042.cfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and (c:IsSetCard(0x256) or c:IsSetCard(0x161))
end
function c21042.condition(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsExists(c21042.cfilter,1,nil) and Duel.IsChainNegatable(ev)
end
function c21042.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c21042.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c21042.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,0x41)==0x41 and c:GetPreviousControler()==tp
		and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEDOWN)
end
function c21042.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c21042.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end