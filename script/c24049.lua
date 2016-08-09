--毒符「猛毒」
function c24049.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_STANDBY_PHASE)
	e1:SetCost(c24049.cost)
	e1:SetOperation(c24049.activate)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CHAIN_UNIQUE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_DRAW)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c24049.condition)
	e2:SetTarget(c24049.target)
	e2:SetOperation(c24049.operation)
	--c:RegisterEffect(e2)
end
function c24049.filter(c)
	return math.abs(c:GetAttack()-c:GetDefence())==200 or math.abs(c:GetAttack()-c:GetDefence())==2000
end
function c24049.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c24049.filter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c24049.filter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c24049.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>=3 and Duel.IsChainDisablable(0) and Duel.SelectYesNo(1-tp,aux.Stringid(24049,0)) then
		local g=Duel.SelectMatchingCard(1-tp,aux.TRUE,tp,0,LOCATION_HAND,3,3,nil)
		Duel.SendtoGrave(g,REASON_EFFECT)
	else
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCountLimit(1)
		e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e2:SetLabel(300)
		e2:SetCondition(c24049.damcon)
		e2:SetOperation(c24049.damop)
		Duel.RegisterEffect(e2,tp)
	end
end
function c24049.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c24049.damop(e,tp,eg,ep,ev,re,r,rp)
	local dam=e:GetLabel()
	Duel.Hint(HINT_CARD,0,24049)
	local danm=Duel.Damage(1-tp,dam,REASON_EFFECT)
	if danm<dam then danm=dam/2 end
	if danm<300 then danm=300 end
	e:SetLabel(danm*2)
end
function c24049.gfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c24049.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DRAW and ep~=tp and e:GetHandler():IsAbleToDeck() and not e:GetHandler():IsStatus(STATUS_CHAINING)
end
function c24049.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c24049.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
		Duel.Damage(1-tp,1000,REASON_EFFECT)
	end
end
