 --しろかみ 谢莉卡·库里姆佐
function c60024.initial_effect(c)
	--target
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60024,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c60024.target)
	e1:SetOperation(c60024.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CHAIN_UNIQUE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--atk down
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60024,1))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c60024.atkcon)
	e3:SetTarget(c60024.atktg)
	e3:SetOperation(c60024.atkop)
	c:RegisterEffect(e3)
end
function c60024.lvfilter(c)
	return c:GetLevel()>0 and c:IsSetCard(0x191) and c:IsFaceup()
end
function c60024.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsType(TYPE_MONSTER) end
	if chk==0 then return Duel.IsExistingTarget(c60024.lvfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c60024.lvfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
end
function c60024.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(tc:GetLevel())
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end
end
function c60024.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
		and re:GetHandler():IsSetCard(0x191)
end
function c60024.atkfilter(c)
	return c:IsFaceup()
end
function c60024.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:IsControler(1-tp) and c60024.atkfilter(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c60024.atkfilter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c60024.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(0)
		tc:RegisterEffect(e1)
	end
end
