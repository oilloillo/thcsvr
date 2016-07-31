--决战符『盾墙』
function c37012.initial_effect(c)
	--turnset
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EFFECT_CANNOT_TURN_SET)
	e0:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c37012.condition)
	e1:SetTarget(c37012.target)
	e1:SetOperation(c37012.activate)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_DEFENCE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(c37012.val)
	c:RegisterEffect(e2)

	if c37012.counter == nil then
		c37012.counter = true
		Uds.regUdsEffect(e1,37012)
	end
end
function c37012.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLocation()~=LOCATION_HAND and e:GetHandler():GetPreviousLocation()~=LOCATION_HAND and Duel.GetAttacker():GetControler()~=tp
end
function c37012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetHandler() and e:GetHandler():IsOnField() then 
		Duel.SetChainLimit(c37012.chainlimit)
	end
end
function c37012.chainlimit(e,rp,tp)
	return e:GetHandler():IsSetCard(0x214)
end
function c37012.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsAttackPos,tp,LOCATION_MZONE,0,nil)
	if Duel.GetMatchingGroupCount(Card.IsDiscardable,tp,LOCATION_HAND,0,nil)>0 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(37012,1)) then
		Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
		Duel.ChangePosition(g,POS_FACEUP_DEFENCE)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetRange(LOCATION_SZONE)
		e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_EVENT+0xfe0000)
		e1:SetCondition(c37012.rdcon)
		e1:SetOperation(c37012.rdop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c37012.rdcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c37012.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(tp,ev/2)
end
function c37012.val(e,c)
	return Duel.GetMatchingGroupCount(Card.IsSetCard,c:GetControler(),LOCATION_GRAVE,0,nil,0x186)*300
end
