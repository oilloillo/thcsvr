 
--逆袭的天邪鬼✿鬼人正邪
function c29016.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP_ATTACK,1)
	e1:SetCondition(c29016.spcon)
	e1:SetOperation(c29016.spop)
	c:RegisterEffect(e1)
	--effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29016,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCost(c29016.cost)
	e2:SetTarget(c29016.target)
	e2:SetOperation(c29016.operation)
	c:RegisterEffect(e2)
	--effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(29016,1))
	e3:SetCategory(CATEGORY_DRAW+CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c29016.tg)
	e3:SetOperation(c29016.op)
	c:RegisterEffect(e3)
end

c29016.DescSetName=0x826

function c29016.filter(c)
	return c:IsFaceup() and c:IsReleasable()
end
function c29016.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c29016.filter,tp,0,LOCATION_MZONE,1,nil)
end
function c29016.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c29016.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c29016.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttack()>=1100 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	e1:SetValue(-1100)
	e:GetHandler():RegisterEffect(e1)
end
function c29016.adfilter(c)
	return c:GetAttack()+c:GetDefence()
end
function c29016.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local tg=g:GetMaxGroup(c29016.adfilter)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,tg:GetCount(),0,0)
	end
end
function c29016.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local tg=g:GetMaxGroup(c29016.adfilter)
		Duel.Destroy(tg,REASON_EFFECT)
	end
end
function c29016.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c29016.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		e1:SetValue(1100)
		c:RegisterEffect(e1)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
