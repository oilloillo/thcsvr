 
--妖魔书-天狗的道歉信文
function c21470007.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c21470007.reset)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21470007,0))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCost(c21470007.cost)
	e2:SetCondition(c21470007.condition)
	e2:SetTarget(c21470007.target)
	e2:SetOperation(c21470007.operation)
	c:RegisterEffect(e2)
end
function c21470007.reset(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():SetTurnCounter(0)
	e:GetHandler():ResetFlagEffect(21470007)
end
function c21470007.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,21470007)<=1 end
	Duel.RegisterFlagEffect(tp,21470007,RESET_PHASE+PHASE_END,0,1)
end
function c21470007.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and eg:GetFirst():GetControler()==tp and eg:GetFirst():IsSetCard(0x742)
end
function c21470007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsLocation(LOCATION_SZONE) and e:GetHandler():IsFaceup() end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,1-tp,1000)
end
function c21470007.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetFlagEffect(tp,21470006)<=1 and e:GetHandler():IsLocation(LOCATION_SZONE) and e:GetHandler():IsFaceup() then 
	Duel.Recover(ep,1000,REASON_EFFECT)
	Duel.Draw(1-ep,1,REASON_EFFECT)
	if e:GetHandler():GetTurnCounter()==0 and e:GetHandler():GetFlagEffect(21470007)==0 then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetRange(LOCATION_SZONE)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		e2:SetOperation(c21470007.destroy)
		e:GetHandler():RegisterEffect(e2)
		e:GetHandler():RegisterFlagEffect(21470007,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,1)
	end
	Duel.RegisterFlagEffect(tp,21470006,RESET_PHASE+PHASE_END,0,1)
	end
end
function c21470007.destroy(e,tp,eg,ep,ev,re,r,rp)
	if tp~=Duel.GetTurnPlayer() then return end
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==2 then Duel.Destroy(e:GetHandler(),REASON_EFFECT) end
end