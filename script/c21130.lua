 
--狂符「幻视调律」
function c21130.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--lv down
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_LEVEL)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0x16,0)
	e2:SetTarget(c21130.tg)
	e2:SetValue(-2)
	c:RegisterEffect(e2)
	--tuner
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21130,0))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(c21130.target)
	e3:SetOperation(c21130.operation)
	c:RegisterEffect(e3)
end
function c21130.tg(e,c)
	return c:IsSetCard(0x256)
end
function c21130.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x256) and not c:IsType(TYPE_TUNER)
end
function c21130.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c21130.filter(chkc) end
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost()
		and Duel.IsExistingTarget(c21130.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c21130.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c21130.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(TYPE_TUNER)
		tc:RegisterEffect(e1)
	end
end
