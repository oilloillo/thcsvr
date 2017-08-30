 
--因幡兔 月上的白兔
function c21083.initial_effect(c)
	--tuner
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21083,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c21083.target)
	e1:SetOperation(c21083.operation)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21083,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CHAIN_UNIQUE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c21083.setcon)
	e2:SetCost(c21083.cost)
	e2:SetTarget(c21083.settg)
	e2:SetOperation(c21083.setop)
	c:RegisterEffect(e2)
end

c21083.DescSetName=0x258

function c21083.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x256) and c:IsType(TYPE_TUNER)
end
function c21083.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c21083.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c21083.filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c21083.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
end
function c21083.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_REMOVE_TYPE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(TYPE_TUNER)
		tc:RegisterEffect(e1)
	end
end
function c21083.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c21083.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,21083)==0 end
	Duel.RegisterFlagEffect(tp,21083,RESET_PHASE+PHASE_END,0,1)
end
function c21083.sfilter(c)
	return c:IsSetCard(0x257) and c:IsSSetable()
end
function c21083.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c21083.sfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c21083.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c21083.sfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
		Duel.ConfirmCards(1-tp,g)
	end
end
