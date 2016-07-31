 
--反魂蝶 -伍分咲-
function c20098.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c20098.cost)
	e1:SetTarget(c20098.target)
	e1:SetOperation(c20098.activate)
	c:RegisterEffect(e1)
end
function c20098.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,20098)==0 end
	Duel.RegisterFlagEffect(tp,20098,RESET_PHASE+PHASE_END,0,1)
end
function c20098.xfilter(c)
	return c:IsFaceup() and c:IsCode(20086) and c:GetCounter(0x28b)>4
end
function c20098.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	and Duel.IsExistingMatchingCard(c20098.xfilter,tp,LOCATION_SZONE,0,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,sg,sg:GetCount(),0,0)
end
function c20098.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if Duel.SendtoGrave(sg,REASON_EFFECT) then
		Duel.SetLP(1-tp,Duel.GetLP(1-tp)/2) 
	end
	if Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) and
		Duel.SelectYesNo(tp,aux.Stringid(20098,0)) then
		cg=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,0,1,1,nil)
		cg:GetFirst():AddCounter(0x28b,1)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_AVAILABLE_BD)
	e1:SetTargetRange(0,1)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetValue(c20098.rdval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c20098.rdval(e,re,val,r,rp,rc)
	return val/2
end
