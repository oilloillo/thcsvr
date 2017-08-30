--异世魔界的夜游神✿神绮
function c15077.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,15077)
	e1:SetCondition(c15077.spcon)
	e1:SetOperation(c15077.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e2)
end
function c15077.spfilter(c)
	return c:IsFaceup() and c:IsAbleToGraveAsCost()
end
function c15077.spcon(e,c)
	if c==nil then return true end
	local ct=Duel.GetMatchingGroupCount(c15077.spfilter,c:GetControler(),LOCATION_ONFIELD,0,nil)
	if ct>3 then ct=3 end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-ct and ct>0
end
function c15077.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c15077.spfilter,tp,LOCATION_ONFIELD,0,1,3,nil)
	Duel.SendtoGrave(g,REASON_COST)
	local gc=g:GetCount()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(gc*800)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
	if gc==3 then
		local e2=Effect.CreateEffect(c)
		e2:SetCategory(CATEGORY_TOGRAVE)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EVENT_SPSUMMON_SUCCESS)
		e2:SetReset(RESET_EVENT+0xff0000)
		e2:SetCost(c15077.cost)
		e2:SetTarget(c15077.target)
		e2:SetOperation(c15077.operation)
		c:RegisterEffect(e2)
	end
	if gc>=2 then
		--cannot be targeted
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetValue(aux.tgoval)
		c:RegisterEffect(e3)
	end
	if gc==1 then
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e4:SetReset(RESET_EVENT+0x1fe0000)
		e4:SetValue(1)
		c:RegisterEffect(e4,true)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e5:SetReset(RESET_EVENT+0x1fe0000)
		e5:SetValue(1)
		c:RegisterEffect(e5,true)
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e6:SetReset(RESET_EVENT+0x1fe0000)
		e6:SetValue(1)
		c:RegisterEffect(e6,true)
	end
end
function c15077.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local fa=Duel.GetFlagEffect(tp,15000)
	local fb=Duel.GetFlagEffect(tp,150000)
	local fc=fa-fb
	if chk==0 then return fc<3 end
	Duel.RegisterFlagEffect(tp,15000,RESET_PHASE+PHASE_END,0,1)
end
function c15077.filter(c)
	return c:IsLevelBelow(10) and c:IsAbleToGrave()
end
function c15077.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c15077.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c15077.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c15077.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
