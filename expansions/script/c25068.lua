--悔悟之棒
function c25068.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c25068.target)
	e1:SetOperation(c25068.operation)
	c:RegisterEffect(e1)
	--def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(200)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(25068,0))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c25068.descon)
	e3:SetTarget(c25068.destg)
	e3:SetOperation(c25068.desop)
	c:RegisterEffect(e3)	
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(25068,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCost(c25068.scost)
	e4:SetTarget(c25068.stg)
	e4:SetOperation(c25068.sop)
	c:RegisterEffect(e4)
	--Equip limit
	local e5=Effect.CreateEffect(c)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_EQUIP_LIMIT)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	if not c25068.global_check then
		c25068.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLE_DESTROYED)
		ge1:SetOperation(c25068.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c25068.checkop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local at=Duel.GetAttackTarget()
	if a:IsStatus(STATUS_BATTLE_DESTROYED) and at:IsStatus(STATUS_BATTLE_DESTROYED) then return end
	local tc=a
	if a:IsStatus(STATUS_BATTLE_DESTROYED) then tc=at end
	tc:RegisterFlagEffect(25068,RESET_EVENT+0x1fe0000,0,1)
end
function c25068.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c25068.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c25068.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget():IsPosition(POS_FACEUP_ATTACK)
end
function c25068.desfilter(c)
	local ct=c:GetFlagEffect(25068)
	return c:IsDestructable() and ct>0
end
function c25068.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(c25068.desfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c25068.desfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	local dam=g:GetFirst():GetFlagEffect(25068)*1000
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c25068.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local ct=tc:GetFlagEffect(25068)
		if Duel.Destroy(tc,REASON_EFFECT)>0 then		
			Duel.Damage(1-tp,ct*1000,REASON_EFFECT)
		end
	end
end
function c25068.scost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetHandler():GetEquipTarget()
	if chk==0 then return ec:GetControler()==tp and ec:IsReleasable() end
	Duel.Release(ec,REASON_COST)
end
function c25068.sfilter(c)
	return c:IsCode(25064) and c:IsAbleToHand()
end
function c25068.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c25068.sfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c25068.sop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstMatchingCard(c25068.sfilter,tp,LOCATION_DECK,0,nil)
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end