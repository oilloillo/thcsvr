 
--WhiteSisterRam
function c70050.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,3,2,c70050.ovfilter,aux.Stringid(70050,0))
	c:EnableReviveLimit()
	--destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c70050.destg)
	e1:SetValue(c70050.value)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(70050,2))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c70050.discon)
	e2:SetCost(c70050.cost)
	e2:SetTarget(c70050.distg)
	e2:SetOperation(c70050.disop)
	c:RegisterEffect(e2)
end
function c70050.ovfilter(c)
	return c:IsFaceup() and c:IsCode(70047) and bit.band(c:GetSummonType(),SUMMON_TYPE_NORMAL)==SUMMON_TYPE_NORMAL
end
function c70050.dfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSetCard(0x149) and not c:IsReason(REASON_REPLACE) and c:IsControler(tp)
end
function c70050.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not eg:IsContains(e:GetHandler())
		and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) and eg:IsExists(c70050.dfilter,1,nil,tp) end
	if Duel.SelectYesNo(tp,aux.Stringid(70050,1)) then
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		return true
	else return false end
end
function c70050.value(e,c)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSetCard(0x149) and not c:IsReason(REASON_REPLACE) and c:IsControler(e:GetHandlerPlayer())
end
function c70050.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and ep~=tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c70050.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x149) and c:GetDefence()>=2000
end
function c70050.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.IsExistingMatchingCard(c70050.cfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	g=Duel.SelectMatchingCard(tp,c70050.cfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	tc=g:GetFirst()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_DEFENCE)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	e1:SetValue(-2000)
	tc:RegisterEffect(e1)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c70050.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c70050.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) then
		Duel.Damage(1-tp,1000,REASON_EFFECT)
	end
end
