 
--绯想✿灵乌路空
function c200019.initial_effect(c)	
	--code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(24019)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(200019,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(c200019.cost)
	e2:SetOperation(c200019.op1)
	c:RegisterEffect(e2)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c200019.spcon)
	c:RegisterEffect(e1)
	--des
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetDescription(aux.Stringid(200019,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c200019.tg2)
	e2:SetOperation(c200019.op2)
	c:RegisterEffect(e2)
	--synchro summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetValue(c200019.synlimit)
	c:RegisterEffect(e4)
end
function c200019.synlimit(e,c)
	if not c then return false end
	if c:IsSetCard(0x5208) then
	return else return not c:IsSetCard(0x120) end
end
function c200019.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c200019.op1(e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.CreateToken(tp,200119)
	Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
--	Duel.RaiseEvent(token,EVENT_CHAIN_SOLVED,token:GetActivateEffect(),0,tp,tp,Duel.GetCurrentChain())
end
function c200019.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLP(tp)<=1000
end
function c200019.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler()==re:GetHandler()
	and Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,sg:GetCount()*500)
end
function c200019.filter2(c)
	return c:IsCode(200219) and c:IsAbleToHand()
end
function c200019.op2(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local ct=Duel.Destroy(sg,REASON_EFFECT)
	Duel.Damage(1-tp,ct*500,REASON_EFFECT)
	if Duel.IsExistingMatchingCard(c200019.filter2,tp,LOCATION_DECK,0,1,nil) then
		Duel.BreakEffect()
		local g=Duel.GetFirstMatchingCard(c200019.filter2,tp,LOCATION_DECK,0,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end