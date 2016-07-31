 
--红魔-芙兰朵露·斯卡雷特
function c22028.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x813),1)
	c:EnableReviveLimit()
	--attack cost
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ATTACK_COST)
	e1:SetCost(c22028.atcost)
	e1:SetOperation(c22028.atop)
	c:RegisterEffect(e1)
	--Race
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_ADD_RACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(RACE_FIEND)
	c:RegisterEffect(e2)
	--indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_NO_TURN_RESET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e3:SetCountLimit(1)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22028,0))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c22028.descost)
	e4:SetTarget(c22028.destg)
	e4:SetOperation(c22028.desop)
	c:RegisterEffect(e4)
	--maintain
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetOperation(c22028.mtop)
	c:RegisterEffect(e5)
	--cannot special summon
	local e6=Effect.CreateEffect(c)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_SPSUMMON_CONDITION)
	e6:SetValue(aux.FALSE)
	c:RegisterEffect(e6)
end
c22028.DescSetName = 0xa3
function c22028.atcost(e,c,tp)
	return Duel.IsExistingMatchingCard(c22028.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e:GetHandler())
end
function c22028.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c22028.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,e:GetHandler())
	Duel.Destroy(g,REASON_COST)
end
function c22028.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,Duel.GetLP(tp)/2)
end
function c22028.filter1(c,e)
	return (c:IsFaceup() and c:IsDestructable() and c:IsType(TYPE_MONSTER)) or (c:IsFaceup() and c:IsCode(22111) and c:GetEquipTarget()==e)
end
function c22028.filter2(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c22028.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22028.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local sg=Duel.GetMatchingGroup(c22028.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c22028.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c22028.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.Destroy(sg,REASON_EFFECT)
end
function c22028.mtop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp then return end
	if Duel.GetLP(tp)>1000 and Duel.SelectYesNo(tp,aux.Stringid(22028,1)) then
		Duel.PayLPCost(tp,1000)
	else
		Duel.Destroy(e:GetHandler(),REASON_RULE)
	end
end
