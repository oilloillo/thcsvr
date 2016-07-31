 
--骚符「活着的骚灵」
function c20115.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCondition(c20115.condition)
	e1:SetCost(c20115.cost)
	e1:SetTarget(c20115.target)
	e1:SetOperation(c20115.activate)
	c:RegisterEffect(e1)
	if not c20115.global_check then
		c20115.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge1:SetOperation(c20115.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c20115.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if not tc:IsSetCard(0x163) then
		Duel.RegisterFlagEffect(tc:GetControler(),20115,RESET_PHASE+PHASE_END,0,1)
	end
end
function c20115.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated() 
end
function c20115.cfilter(c)
	return not c:IsSetCard(0x163)
end
function c20115.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x163)
end
function c20115.hfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c20115.afilter(c)
	return c:IsSetCard(0x163) and c:IsFaceup()
end
function c20115.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,20115)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_OATH)
	e1:SetTarget(aux.TargetBoolFunction(c20115.cfilter))
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c20115.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c20115.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c20115.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c20115.hfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c20115.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c20115.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,c20115.hfilter,tp,LOCATION_GRAVE,0,1,73,nil)
		Duel.HintSelection(g)
		local gc=g:GetCount()
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		local at=Duel.GetMatchingGroup(c20115.afilter,tp,LOCATION_MZONE,0,nil)
		local ct=at:GetClassCount(Card.GetCode)
		local atk=gc*ct*300+900
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(atk)
		tc:RegisterEffect(e1)
	end
end
