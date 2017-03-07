--魔界双子魔法使✿雪&舞
function c15051.initial_effect(c)
	--true light material
	Fus.AddFusionProcFun2(c,c15051.mfilter1,c15051.mfilter2,true)
	c:EnableReviveLimit()
	--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c15051.condition)
	e1:SetOperation(c15051.sumsuc)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE)
	e2:SetDescription(aux.Stringid(15051,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c15051.descon1)
	e2:SetCost(c15051.cost)
	e2:SetTarget(c15051.destg)
	e2:SetOperation(c15051.desop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCost(c15051.descon2)
	c:RegisterEffect(e3)
end
function c15051.mfilter1(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsLevelAbove(4)
end
function c15051.mfilter2(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsLevelBelow(6)
end
function c15051.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION
end
function c15051.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,150000,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(tp,150000,RESET_PHASE+PHASE_END,0,1)
	Duel.SetChainLimitTillChainEnd(aux.FALSE)
end
function c15051.descon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c15051.descon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c15051.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local fa=Duel.GetFlagEffect(tp,15000)
	local fb=Duel.GetFlagEffect(tp,150000)
	local fc=fa-fb
	if chk==0 then return fc<3 end
	Duel.RegisterFlagEffect(tp,15000,RESET_PHASE+PHASE_END,0,1)
end
function c15051.filter(c)
	return c:IsDestructable()
end
function c15051.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c15051.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c15051.filter,tp,0,LOCATION_MZONE,1,nil) and c:GetAttack()>=200 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c15051.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c15051.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(-200)
		e:GetHandler():RegisterEffect(e1)
	end
end
