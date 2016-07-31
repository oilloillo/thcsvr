 
--舰上侦察机-彩云
function c50854.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c50854.target)
	e1:SetOperation(c50854.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetValue(c50854.eqlimit)
	c:RegisterEffect(e2)
	--confilm
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(50854,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c50854.sgtg)
	e3:SetOperation(c50854.sgop)
	c:RegisterEffect(e3)
	--indestructable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e4:SetCountLimit(1)
	e4:SetValue(c50854.valcon)
	c:RegisterEffect(e4)
	--recover
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(50854,1))
	e5:SetCategory(CATEGORY_RECOVER)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_REPEAT)
	e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(c50854.rctg)
	e5:SetOperation(c50854.rcop)
	c:RegisterEffect(e5)
end
function c50854.eqlimit(e,c)
	return c:IsSetCard(0x64bb)
end
function c50854.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x64bb)
end
function c50854.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c50854.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c50854.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c50854.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c50854.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c50854.cffilter(c)
	return not c:IsPublic()
end
function c50854.sgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c50854.cffilter,tp,0,0xe,1,nil) end
end
function c50854.sgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c50854.cffilter,tp,0,0xe,nil)
	if g:GetCount()>0 then
		Duel.ConfirmCards(tp,g)
		Duel.ShuffleHand(1-tp)
	end
end
function c50854.valcon(e,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end
function c50854.rctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
end
function c50854.rcop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Recover(p,d,REASON_EFFECT)
	end
end
