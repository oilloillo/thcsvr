 
--大合葬「灵车大协奏曲」
function c20118.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c20118.cost)
	e1:SetTarget(c20118.target)
	e1:SetOperation(c20118.operation)
	c:RegisterEffect(e1)
	if not c20118.global_check then
		c20118.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c20118.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge2:SetOperation(c20118.checkop1)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge3:SetOperation(c20118.clear)
		Duel.RegisterEffect(ge3,0)
	end
end
function c20118.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if tc:IsSetCard(0x163) then
		Duel.RegisterFlagEffect(rp,20118,RESET_PHASE+PHASE_END,0,1)
	end
end
function c20118.checkop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if not tc:IsType(TYPE_SPIRIT) then
			c20118[tc:GetSummonPlayer()]=false
		end
		tc=eg:GetNext()
	end
end
function c20118.clear(e,tp,eg,ep,ev,re,r,rp)
	c20118[0]=true
	c20118[1]=true
end
function c20118.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c20118[tp] end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c20118.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c20118.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsType(TYPE_SPIRIT)
end
function c20118.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsDestructable() end
	if chk==0 then return Duel.GetFlagEffect(tp,20118)>3
		and Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,2,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,2,2,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c20118.operation(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(sg,REASON_EFFECT)
end
