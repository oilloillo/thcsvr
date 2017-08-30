 
--妖魔书变化 烟烟罗
function c21470014.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--negate attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21470014,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c21470014.dcost)
	e1:SetCondition(c21470014.condition)
	e1:SetTarget(c21470014.target)
	e1:SetOperation(c21470014.operation)
	c:RegisterEffect(e1)
	--des
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21470014,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c21470014.dcost)
	e2:SetTarget(c21470014.dtg)
	e2:SetOperation(c21470014.dop)
	c:RegisterEffect(e2)
end
function c21470014.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function c21470014.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetAttacker()
	if chkc then return chkc==tg end
	if chk==0 then return tg:IsOnField() and tg:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tg)
end
function c21470014.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end
function c21470014.dfilter(c)
	return c:IsFaceup()
end
function c21470014.dcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0
		and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c21470014.dtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) end
	if chk==0 then return Duel.IsExistingTarget(c21470014.dfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c21470014.dfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
end
function c21470014.dop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetRange(0x20c)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetOperation(c21470014.desop)
		tc:RegisterEffect(e1)
	end
end
function c21470014.desop(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandlerPlayer()
	if Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)>0 then Duel.Damage(p,500,REASON_EFFECT) end
end
