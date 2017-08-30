 
--废狱-地底的太阳·灵乌路空
function c24019.initial_effect(c)
	c:SetUniqueOnField(1,1,24019)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c24019.spcon)
	e1:SetOperation(c24019.spop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetDescription(aux.Stringid(24019,0))
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c24019.cost)
	e2:SetTarget(c24019.target)
	e2:SetOperation(c24019.operation)
	c:RegisterEffect(e2)
	--synchro summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetValue(c24019.synlimit)
	c:RegisterEffect(e4)
end
function c24019.synlimit(e,c)
	if not c then return false end
	if c:IsSetCard(0x5208) then
	return else return not c:IsSetCard(0x120) end
end
function c24019.spfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x625) and c:IsAbleToRemoveAsCost()
end
function c24019.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c24019.spfilter,tp,LOCATION_GRAVE,0,3,nil)
end
function c24019.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c24019.spfilter,tp,LOCATION_GRAVE,0,3,3,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c24019.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500)
	else Duel.PayLPCost(tp,500) end
end
function c24019.filter(c)
	return not c:IsAttribute(ATTRIBUTE_FIRE) and c:IsDestructable() and c:IsFaceup()
end
function c24019.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c24019.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(c24019.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c24019.cfilter(c)
	return not c:IsPublic() and c:IsType(TYPE_MONSTER)
end
function c24019.operation(e,tp,eg,ep,ev,re,r,rp)
	local dis=false
	local sg=Duel.GetMatchingGroup(c24019.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if sg and Duel.IsChainDisablable(0) then
		local g=Duel.GetMatchingGroup(c24019.cfilter,tp,0,LOCATION_HAND,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(1-tp,aux.Stringid(24019,1)) then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CONFIRM)
			local cg=g:Select(1-tp,1,1,nil)
			Duel.ConfirmCards(tp,cg)
			Duel.ShuffleHand(1-tp)
			dis=true
		end
	end
	if not dis then Duel.Destroy(sg,REASON_EFFECT)
    end
end
