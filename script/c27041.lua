 
--神光「无忤为宗」
function c27041.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c27041.cost)
	e1:SetTarget(c27041.target)
	e1:SetOperation(c27041.activate)
	c:RegisterEffect(e1)
end
function c27041.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,27041)==0 end
	Duel.RegisterFlagEffect(tp,27041,RESET_PHASE+PHASE_END,0,3)
end
function c27041.filter(c)
	return c:IsSetCard(0x208) or not c:IsType(TYPE_MONSTER)
end
function c27041.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD+LOCATION_HAND,4,e:GetHandler())
		and Duel.IsExistingMatchingCard(c27041.filter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,2,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,PLAYER_ALL,LOCATION_ONFIELD+LOCATION_HAND)
end
function c27041.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(1-tp,aux.TRUE,1-tp,LOCATION_ONFIELD+LOCATION_HAND,0,2,2,e:GetHandler())
	local g2=Duel.SelectMatchingCard(tp,c27041.filter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,2,2,e:GetHandler())
	g1:Merge(g2)
	Duel.HintSelection(g1)
	local d=Duel.SendtoGrave(g1,nil,2,REASON_EFFECT)
	if d==0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end
