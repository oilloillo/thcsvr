 
--梦与传统的巫女 博丽灵梦
function c11001.initial_effect(c)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(c11001.indes)
	c:RegisterEffect(e1)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(11001,0))
	--e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DAMAGE_STEP_END)
	e4:SetCost(c11001.cost)
	e4:SetTarget(c11001.destg)
	e4:SetOperation(c11001.desop)
	c:RegisterEffect(e4)
end
function c11001.indes(e,c)
	return c:IsSetCard(0x208) and c:GetAttack()>=2400
end
function c11001.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1500) end
	Duel.PayLPCost(tp,1500)
end
function c11001.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetHandler():GetBattleTarget()
	if chk==0 then return e:GetHandler():IsRelateToBattle() and bc and bc:IsRelateToBattle() and bc:IsSetCard(0x208) end
end
function c11001.desop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if bc:IsRelateToBattle() then
		bc:RegisterFlagEffect(11001,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetReset(RESET_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetLabelObject(bc)
		e2:SetOperation(c11001.op2)
		Duel.RegisterEffect(e2,tp)
	end
end
function c11001.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	if c:GetFlagEffect(11001)>0 then Duel.Destroy(c,REASON_EFFECT) end
end