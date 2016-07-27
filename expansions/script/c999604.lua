--视符『娜兹玲灵摆』
function c999604.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetDescription(aux.Stringid(999604,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetCountLimit(1,999604+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c999604.target)
	e1:SetOperation(c999604.operation)
	c:RegisterEffect(e1)
	--change scale
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(999604,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c999604.cscon)
	e2:SetCost(c999604.cscost)
	e2:SetTarget(c999604.cstarget)
	e2:SetOperation(c999604.csop)
	c:RegisterEffect(e2)
end

function c999604.filter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end

function c999604.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local lpz=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local rpz=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	if chk==0 then return (lpz==nil or rpz==nil) and Duel.IsExistingMatchingCard(c999604.filter, tp, LOCATION_GRAVE+LOCATION_EXTRA, 0, 1, nil) end
end

function c999604.operation(e,tp,eg,ep,ev,re,r,rp)
	local lpz=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local rpz=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	if lpz and rpz then return end
	local g = Duel.SelectMatchingCard(tp,c999604.filter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil)
	Duel.MoveToField(g:GetFirst(), tp, tp, LOCATION_SZONE, POS_FACEUP, true)
end

function c999604.cscon(e,tp,eg,ep,ev,re,r,rp)
	return aux.exccon(e)
end

function c999604.cscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end

function c999604.filter2(c,tp)
	local lpz=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local rpz=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	return (c==lpz or c==rpz) and c:IsFaceup()
end

function c999604.cstarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c999604.filter2(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c999604.filter2,tp,LOCATION_SZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c999604.filter2,tp,LOCATION_SZONE,0,1,1,nil,tp)
end

function c999604.csop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local opt=Duel.SelectOption(tp, aux.Stringid(999604,2), aux.Stringid(999604,3))
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LSCALE)
		e1:SetValue(opt==0 and 1 or -1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_RSCALE)
		tc:RegisterEffect(e2)
	end
end