 
--反魂蝶 -参分咲-
function c20097.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c20097.cost)
	e1:SetTarget(c20097.target)
	e1:SetOperation(c20097.activate)
	c:RegisterEffect(e1)
end
function c20097.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,20097)==0 end
	Duel.RegisterFlagEffect(tp,20097,RESET_PHASE+PHASE_END,0,1)
end
function c20097.xfilter(c)
	return c:IsFaceup() and c:IsCode(20086) and c:GetCounter(0x28b)>2
end
function c20097.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCurrentPhase()==PHASE_MAIN1 
	and Duel.IsExistingMatchingCard(c20097.xfilter,tp,LOCATION_SZONE,0,1,nil) end
end
function c20097.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	local lpc=Duel.GetLP(1-tp)
	Duel.SetLP(1-tp,lpc - 3000 + ct*500) 
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_AVAILABLE_BD)
	e1:SetTargetRange(0,1)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetValue(c20097.rdval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	if Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
		and Duel.SelectYesNo(tp,aux.Stringid(20097,0)) then
		cg=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,0,1,1,nil)
		cg:GetFirst():AddCounter(0x28b,1)
	end
end
function c20097.rdval(e,re,val,r,rp,rc)
	return val/2
end
