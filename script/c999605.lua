--守符『灵摆防御』
--require "expansions/nef/nef"
function c999605.initial_effect(c)
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetDescription(aux.Stringid(999605,0))
	e1:SetCountLimit(1,999605)
	e1:SetCost(c999605.cost)
	e1:SetTarget(c999605.target)
	e1:SetOperation(c999605.activate)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	e2:SetDescription(aux.Stringid(999605,0))
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetDescription(aux.Stringid(999605,0))
	c:RegisterEffect(e3)
	--attack announce
	local e4=e1:Clone()
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetDescription(aux.Stringid(999605,1))
	e4:SetTarget(c999605.target2)
	c:RegisterEffect(e4)
	--effect
	local e5=e1:Clone()
	e5:SetCode(EVENT_CHAINING)
	e5:SetDescription(aux.Stringid(999605,2))
	e5:SetCondition(c999605.condition3)
	e5:SetTarget(c999605.target3)
	c:RegisterEffect(e5)
	--protect
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_ACTIVATE)
	e6:SetDescription(aux.Stringid(999605,3))
	e6:SetCountLimit(1,999605)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetTarget(c999605.target4)
	e6:SetOperation(c999605.activate4)
	c:RegisterEffect(e6)
end

function c999605.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
--summon
function c999605.filter(c,tp,ep,min,max)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsDestructable() 
		and c:GetLevel()>min and c:GetLevel()<max
end

function c999605.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if eg:GetCount()>1 then return end
	local lpz=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local rpz=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	if not (lpz and rpz) then return end
	local tc=eg:GetFirst()
	local ls=Nef.GetFieldLeftScale(tp)
	local rs=Nef.GetFieldRightScale(tp)
	if chk==0 then return c999605.filter(tc, tp, ep, ls<rs and ls or rs, ls>rs and ls or rs) end
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end

function c999605.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
--attack
function c999605.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tc=Duel.GetAttacker()
	local lpz=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local rpz=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	if not (lpz and rpz) then return end
	local ls=Nef.GetFieldLeftScale(tp)
	local rs=Nef.GetFieldRightScale(tp)
	if chk==0 then return c999605.filter(tc, tp, ep, ls<rs and ls or rs, ls>rs and ls or rs) end
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
--effect
function c999605.condition3(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER)
end

function c999605.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=re:GetHandler()
	local lpz=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local rpz=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	if not (lpz and rpz) then return end
	local ls=Nef.GetFieldLeftScale(tp)
	local rs=Nef.GetFieldRightScale(tp)
	if chk==0 then return c999605.filter(tc, tp, ep, ls<rs and ls or rs, ls>rs and ls or rs, 1) 
		and tc:IsRelateToEffect(re) end
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
--protect
function c999605.filter4(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end

function c999605.target4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) and c999605.filter4(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c999605.filter4,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c999605.filter4,tp,LOCATION_ONFIELD,0,1,1,nil)
end

function c999605.activate4(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		tc:RegisterEffect(e3)
	end
end