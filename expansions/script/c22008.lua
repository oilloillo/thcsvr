 
--冰之妖精
function c22008.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22008,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c22008.tg)
	e1:SetOperation(c22008.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--atk change
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22008,1))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLED)
	e3:SetCondition(c22008.condition)
	e3:SetOperation(c22008.operation)
	c:RegisterEffect(e3)
end
function c22008.filter(c)
	return c:GetOriginalCode()==(22090) and c:IsAbleToHand()
end
function c22008.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c22008.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22008.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c22008.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c22008.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c22008.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttackTarget()
end
function c22008.operation(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	if d==e:GetHandler() then d=Duel.GetAttacker() end
	if not d:IsRelateToBattle() then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(900)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	d:RegisterEffect(e1)
end
