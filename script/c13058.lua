--幽光之草莓十字
--Script by Nanahira
function c13058.initial_effect(c)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_TOGRAVE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,130580)
	e1:SetTarget(c13058.target)
	e1:SetOperation(c13058.operation)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetCode(EVENT_CUSTOM+13058)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(0x14000)
	e2:SetCountLimit(1,13058)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return rp==tp
	end)
	e2:SetTarget(c13058.stg)
	e2:SetOperation(c13058.sop)
	c:RegisterEffect(e2)
	if not c13058.gchk then
		c13058.gchk=true
		c13058[0]=5
		c13058[1]=5
		local e3=Effect.GlobalEffect()
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_DESTROYED)
		e3:SetCondition(c13058.addcon)
		e3:SetOperation(c13058.addop)
		Duel.RegisterEffect(e3,0)
	end
end
c13058.count_available=2
function c13058.addcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c13058.dfilter,1,nil) and Duel.IsExistingMatchingCard(c13058.f,rp,LOCATION_GRAVE,0,1,nil)
end
function c13058.f(c)
	return c.count_available==2 and c:IsFaceup()
end
function c13058.addop(e,tp,eg,ep,ev,re,r,rp)
	if c13058[rp]<=1 then
		c13058[rp]=5
		Duel.RaiseEvent(eg,EVENT_CUSTOM+13058,re,r,rp,ep,ev)
	else c13058[rp]=c13058[rp]-1 end
end
function c13058.dfilter(c)
	return bit.band(c:GetPreviousTypeOnField(),TYPE_SPELL+TYPE_TRAP)~=0
end
function c13058.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0xe,0,1,e:GetHandler()) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,0)
end
function c13058.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0xe,0,1,1,c)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	if Duel.SendtoGrave(g,REASON_EFFECT)>0 then
		Duel.Recover(p,1000,REASON_EFFECT)
	end
end
function c13058.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(c13058.cfilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c13058.cfilter(c)
	return c:IsSetCard(0x13e) and c:IsAbleToDeck()
end
function c13058.sop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c13058.cfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	if g:GetCount()>1 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
