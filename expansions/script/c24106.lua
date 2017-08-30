--表象『祖先托梦』
function c24106.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c24106.target)
	e1:SetOperation(c24106.activate)
	c:RegisterEffect(e1)
end
function c24106.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x514a)
end
function c24106.filter2(c)
	return c:IsAbleToRemove() and c:IsType(TYPE_MONSTER)
end
function c24106.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:GetLocation()==LOCATION_GRAVE and chkc:IsAbleToRemove() and chkc:IsType(TYPE_MONSTER) end
	if chk==0 then return Duel.IsExistingTarget(c24106.filter2,tp,0,LOCATION_GRAVE,1,nil) end
	local ct=0
	if Duel.IsExistingMatchingCard(c24106.filter,tp,LOCATION_MZONE,0,1,nil) then
		ct=4
	else
		ct=2
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c24106.filter2,tp,0,LOCATION_GRAVE,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c24106.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	local sbird={}
	local tc=sg:GetFirst()
	while tc do
		sbird[tc:GetCode()] = true
		tc=sg:GetNext()
	end

	local function sbirdTarget(e,c)
		return sbird[c:GetCode()]==true
	end
	
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(0,1)
	e1:SetTarget(sbirdTarget)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
end