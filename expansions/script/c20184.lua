--庭师剑-朱绒楼观双剑
function c20184.initial_effect(c)
	--Equip limit
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_EQUIP_LIMIT)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c20184.cost)
	e1:SetTarget(c20184.target)
	e1:SetOperation(c20184.operation)
	c:RegisterEffect(e1)
	--shinjin
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(20184,2))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c20184.sjtg)
	e2:SetOperation(c20184.sjop)
	c:RegisterEffect(e2)
	--Double Attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--Atkup
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetValue(500)
	c:RegisterEffect(e4)
	--to hand
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(20184,3))
	e8:SetCategory(CATEGORY_TOHAND)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetProperty(EFFECT_FLAG_DELAY)
	e8:SetCode(EVENT_TO_GRAVE)
	e8:SetCondition(c20184.thcon)
	e8:SetTarget(c20184.thtg)
	e8:SetOperation(c20184.thop)
	c:RegisterEffect(e8)
end
function c20184.cfilter(c)
	return c:IsSetCard(0x201) and c:IsAbleToGraveAsCost()
end
function c20184.sfilter(c)
	return c:IsSetCard(0x201) and c:IsAbleToRemoveAsCost()
end
function c20184.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(c20184.cfilter,tp,LOCATION_ONFIELD,0,nil)
	local g2=Duel.GetMatchingGroup(c20184.sfilter,tp,LOCATION_GRAVE,0,nil)
	local c1=g1:GetCount()>=2 and g1:IsExists(Card.IsCode,1,nil,20175)
	local c2=g2:GetCount()>=2 and g2:IsExists(Card.IsCode,1,nil,20175)
	if chk==0 then return c1 or c2 end
	local opt=2
	if c1 then opt=0 end
	if c2 then opt=1 end
	if c1 and c2 then opt=Duel.SelectOption(tp,aux.Stringid(20184,0),aux.Stringid(20184,1)) end
	if opt==0 then
		local qg=g1:FilterSelect(tp,Card.IsCode,1,1,nil,20175)
		local g=g1:Select(tp,1,1,qg:GetFirst())
		qg:Merge(g)
		Duel.SendtoGrave(qg,REASON_COST)
	else
		local qg=g2:FilterSelect(tp,Card.IsCode,1,1,nil,20175)
		local g=g2:Select(tp,1,1,qg:GetFirst())
		qg:Merge(g)
		Duel.Remove(qg,POS_FACEUP,REASON_COST)
	end
end
function c20184.filter(c)
	return c:IsFaceup()
end
function c20184.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c20184.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c20184.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c20184.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c20184.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
    end
end
function c20184.sjtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_SZONE,2,e:GetHandler()) end
	Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_SZONE,2,2,e:GetHandler())
end
function c20184.sjop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	while tc do
		if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e1:SetValue(1)
			tc:RegisterEffect(e1)
		end
		tc=g:GetNext()
	end
end
function c20184.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_LOST_TARGET) and c:GetPreviousEquipTarget():IsLocation(LOCATION_HAND)
end
function c20184.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c20184.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
