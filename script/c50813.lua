 
--61cm三连装鱼雷
function c50813.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c50813.target)
	e1:SetOperation(c50813.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--dd
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(50813,0))
	e3:SetCategory(CATEGORY_DAMAGE+CATEGORY_DESTROY)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetCondition(c50813.thcon)
	e3:SetCost(c50813.cost1)
	e3:SetTarget(c50813.thtg)
	e3:SetOperation(c50813.thop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(50813,0))
	e4:SetCategory(CATEGORY_DAMAGE+CATEGORY_DESTROY)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1)
	e4:SetCondition(c50813.ddcon)
	e4:SetCost(c50813.cost2)
	e4:SetTarget(c50813.thtg)
	e4:SetOperation(c50813.thop)
	c:RegisterEffect(e4)
end
function c50813.eqlimit(e,c)
	return c:IsSetCard(0xc4bb) or c:IsSetCard(0x54bb) or c:IsSetCard(0xa4bb)
end
function c50813.filter(c)
	return c:IsFaceup()
end
function c50813.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c50813.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c50813.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c50813.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c50813.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c50813.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c50813.ddcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_BATTLE and e:GetHandler():GetEquipTarget():IsSetCard(0xa4bb)
end
function c50813.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,50813)==0 end
	Duel.RegisterFlagEffect(tp,50813,RESET_PHASE+PHASE_END,0,1)
end
function c50813.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,508130)==0 end
	Duel.RegisterFlagEffect(tp,508130,RESET_PHASE+PHASE_END,0,1)
end
function c50813.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)
		or not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
		if Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) then
			g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
		else
			Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,400)
		end
end
function c50813.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) then
		local lz=c:GetEquipTarget():GetFlagEffect(50200)
		local dam=lz*200+400
		if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(-dam)
			tc:RegisterEffect(e1)
			if tc:GetAttack()==0 then
				Duel.Destroy(tc,REASON_EFFECT)
			end
		else
			Duel.Damage(1-tp,dam,REASON_EFFECT)
		end
	end
end
