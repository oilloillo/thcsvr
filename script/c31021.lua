--地狱女神✿赫卡提亚·拉碧斯拉祖利
function c31021.initial_effect(c)
	c:EnableReviveLimit()
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c31021.spcon)
	e2:SetOperation(c31021.spop)
	c:RegisterEffect(e2)
	--immune effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(c31021.efilter)
	c:RegisterEffect(e3)
	--qiang,wudi
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c31021.damcon)
	e4:SetOperation(c31021.dop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCondition(c31021.damcon2)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetRange(LOCATION_REMOVED)
	c:RegisterEffect(e6)
	--hen you xiu
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_TO_HAND)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(c31021.condition1)
	e7:SetOperation(c31021.operation)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetRange(LOCATION_GRAVE)
	e8:SetCondition(c31021.condition2)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetRange(LOCATION_REMOVED)
	c:RegisterEffect(e9)
end
function c31021.spfilter(c)
	return (c:IsSetCard(0x275) or c:IsSetCard(0x276)) and c:IsReleasable()
end
function c31021.rfilter(c)
	return c:GetLevel()+c:GetRank()
end
function c31021.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return false end
	local g=Duel.GetMatchingGroup(c31021.spfilter,tp,LOCATION_MZONE,0,nil)
	return g:CheckWithSumGreater(c31021.rfilter,11)
end
function c31021.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c31021.spfilter,c:GetControler(),LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=g:SelectWithSumGreater(tp,c31021.rfilter,8)
	Duel.Release(sg,REASON_COST)
end
function c31021.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c31021.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetBattleDamage(tp)>0
end
function c31021.damcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetBattleDamage(tp)>0 and e:GetHandler():GetPreviousLocation()==LOCATION_ONFIELD
end
function c31021.dop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(tp,0)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c31021.cfilter(c,tp)
	return c:IsControler(tp)
end
function c31021.condition1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c31021.cfilter,1,nil,tp) and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>2
end
function c31021.condition2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c31021.cfilter,1,nil,tp) and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>2 and e:GetHandler():GetPreviousLocation()==LOCATION_ONFIELD
end
function c31021.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)-2
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_HAND,0,ct,ct,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	local dam=Duel.GetOperatedGroup():GetCount()*2000
	local lp=Duel.GetLP(tp)
	Duel.SetLP(tp,lp-dam)
end
