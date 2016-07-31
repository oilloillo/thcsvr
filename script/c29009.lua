 
--竹林的狼人✿今泉影狼
function c29009.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29009,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c29009.cost)
	e1:SetTarget(c29009.target)
	e1:SetOperation(c29009.operation)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29009,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_CHANGE_POS)
	e2:SetCondition(c29009.spcon)
	e2:SetTarget(c29009.sptg)
	e2:SetOperation(c29009.operation)
	c:RegisterEffect(e2)
	if not c29009.global_check then
		c29009.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge1:SetOperation(c29009.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end

c29009.DescSetName=0x826

function c29009.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if not tc:IsCode(29009) then
		Duel.RegisterFlagEffect(tc:GetControler(),29009,RESET_PHASE+PHASE_END,0,1)
	end
end
function c29009.cfilter(c)
	return not c:IsCode(29009)
end
function c29009.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,29009)==0 and Duel.GetFlagEffect(tp,290090)==0 and e:GetHandler():GetAttack()>=1000 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	e1:SetValue(-1000)
	e:GetHandler():RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	--e2:SetProperty(EFFECT_FLAG_OATH)
	e2:SetTarget(aux.TargetBoolFunction(c29009.cfilter))
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	Duel.RegisterFlagEffect(tp,290090,RESET_PHASE+PHASE_END,0,1)
end
function c29009.desfilter(c)
	return c:IsDestructable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c29009.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsDestructable() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_MZONE,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c29009.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c29009.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsDefencePos()
end
function c29009.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsOnfield() and chkc:IsDestructable() end
	if chk==0 then return Duel.GetFlagEffect(tp,2900900)==0 and Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.RegisterFlagEffect(tp,2900900,RESET_PHASE+PHASE_END,0,1)
end
