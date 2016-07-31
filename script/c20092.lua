 
--幽曲「埋骨于弘川」
function c20092.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(20092,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c20092.cost)
	e1:SetTarget(c20092.addct)
	e1:SetOperation(c20092.addc)
	c:RegisterEffect(e1)
	if not c20092.global_check then
		c20092.global_check=true
		c20092[0]=true
		c20092[1]=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c20092.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c20092.clear)
		Duel.RegisterEffect(ge2,0)
	end
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(20092,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c20092.target)
	e2:SetOperation(c20092.activate)
	c:RegisterEffect(e2)
end
function c20092.checkop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():GetCode()==20099 then return end
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and re:GetHandler():GetControler()==e:GetHandler():GetControler() then
		c20092[e:GetHandler():GetControler()]=false
	end
end
function c20092.clear(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()==e:GetHandler():GetControler() then return end
	c20092[0]=true
	c20092[1]=true
end
function c20092.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c20092[tp] end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c20092.aclimit)
	if Duel.GetTurnPlayer()==tp then
		e1:SetReset(RESET_PHASE+PHASE_END)
	else
		e1:SetReset(RESET_PHASE+PHASE_END,2)
	end
	Duel.RegisterEffect(e1,tp)
end
function c20092.aclimit(e,re,tp)
	return re:GetHandler():IsType(TYPE_SPELL+TYPE_TRAP) and re:GetHandler():GetCode()~=20099
end
function c20092.xfilter(c)
	return c:IsFaceup() and c:IsCode(20086) and c:GetCounter(0x28b)<8
end
function c20092.addct(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c20092.xfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c20092.xfilter,tp,LOCATION_SZONE,0,1,e:GetHandler()) end
	Duel.SelectTarget(tp,c20092.xfilter,tp,LOCATION_SZONE,0,1,1,e:GetHandler())
end
function c20092.addc(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		tc:AddCounter(0x28b,8-tc:GetCounter(0x28b))
	end
end
function c20092.filter(c)
	return c:IsSetCard(0x317) or c:IsSetCard(0x684)
end
function c20092.tgfilter(c)
	return c:IsSetCard(0x684) and c:IsAbleToGrave()
end
function c20092.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(c20092.filter,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return ct>0 
		and Duel.IsExistingMatchingCard(c20092.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c20092.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c20092.filter,tp,LOCATION_GRAVE,0,nil)*3
	if ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c20092.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,ct,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
