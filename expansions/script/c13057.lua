--弧光之草莓十字
--Script by Nanahira and 你们撒嘛
function c13057.initial_effect(c)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,130570)
	e1:SetTarget(c13057.target)
	e1:SetOperation(c13057.operation)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_F)
	e2:SetCode(EVENT_CUSTOM+13057)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,13057)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return rp==tp
	end)
	e2:SetTarget(c13057.stg)
	e2:SetOperation(c13057.sop)
	c:RegisterEffect(e2)
	if c13057.counter==nil then
		c13057.counter=true
		c13057[0]=4
		c13057[1]=4
		local e3=Effect.GlobalEffect()
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_CHAINING)
		e3:SetCondition(c13057.addcd)
		e3:SetOperation(c13057.addcount)
		Duel.RegisterEffect(e3,0)
	end
end
c13057.count_available=1
function c13057.addcd(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsSetCard(0x13e) and Duel.IsExistingMatchingCard(c13057.f,rp,LOCATION_REMOVED,0,1,nil)
end
function c13057.f(c)
	return c.count_available==1 and c:IsFaceup()
end
function c13057.addcount(e,tp,eg,ep,ev,re,r,rp)
	if c13057[rp]<=1 then
		c13057[rp]=4
		Duel.RaiseEvent(eg,EVENT_CUSTOM+13057,re,r,rp,ep,ev)
	else c13057[rp]=c13057[rp]-1 end
end
function c13057.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0xe,0,1,e:GetHandler()) and e:GetHandler():IsAbleToRemove() end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),2,0,0)
end
function c13057.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0xe,0,1,1,c)
	g:AddCard(c)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 then
		Duel.Recover(p,1000,REASON_EFFECT)
	end
end
function c13057.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c13057.sfilter,tp,0x21,0,1,nil) end
end
function c13057.sfilter(c)
	return c:IsSetCard(0x13e) and c:IsType(TYPE_TRAP) and c:IsSSetable(true)
end
function c13057.sop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0
		or not Duel.IsExistingMatchingCard(c13057.sfilter,tp,0x21,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c13057.sfilter,tp,0x21,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
		Duel.ConfirmCards(1-tp,g)
	end
end
