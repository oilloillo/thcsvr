 
--夜棱镜✿虹川三姐妹
function c20110.initial_effect(c)
	--tribute check
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(c20110.valcheck)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c20110.spcon)
	e1:SetOperation(c20110.spop)
	c:RegisterEffect(e1)
	--summon,flip,special
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(c20110.retreg)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetDescription(aux.Stringid(20110,0))
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(c20110.target)
	e5:SetOperation(c20110.operation)
	c:RegisterEffect(e5)
end
function c20110.valcheck(e,c)
	local g=c:GetMaterial()
	local ct=g:FilterCount(Card.IsSetCard,nil,0x163)
	if ct>0 then
		e:GetHandler():RegisterFlagEffect(20110,RESET_EVENT+0xff0000,0,0)
	end
end
function c20110.spfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and c:IsSetCard(0x163)
end
function c20110.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c20110.spfilter,tp,LOCATION_GRAVE,0,3,nil)
end
function c20110.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c20110.spfilter,tp,LOCATION_GRAVE,0,3,3,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	local g1=g:GetFirst()
	local a1=g1:GetAttribute()
	--g:RemoveCard(g1)
	local g2=g:GetNext()
	local a2=g2:GetAttribute()
	--g:RemoveCard(g2)
	local g3=g:GetNext()
	local a3=g3:GetAttribute()
	if a1~=a2 and a1~=a3 and a2~=a3 then
		e:GetHandler():RegisterFlagEffect(20110,RESET_EVENT+0xff0000,0,0)
	end
end
function c20110.retreg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetDescription(aux.Stringid(20110,1))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_REPEAT)
	e1:SetReset(RESET_EVENT+0x1ee0000+RESET_PHASE+PHASE_END)
	e1:SetCondition(c20110.retcon)
	e1:SetTarget(c20110.rettg)
	e1:SetOperation(c20110.retop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	c:RegisterEffect(e2)
end
function c20110.retcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsHasEffect(EFFECT_SPIRIT_DONOT_RETURN) then return false end
	if e:IsHasType(EFFECT_TYPE_TRIGGER_F) then
		return not c:IsHasEffect(EFFECT_SPIRIT_MAYNOT_RETURN)
	else return c:IsHasEffect(EFFECT_SPIRIT_MAYNOT_RETURN) end
end
function c20110.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c20110.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
function c20110.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c20110.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c20110.filter,tp,0,LOCATION_ONFIELD,1,nil)
		and e:GetHandler():GetFlagEffect(20110)>0 end
	local sg=Duel.GetMatchingGroup(c20110.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c20110.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c20110.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end
