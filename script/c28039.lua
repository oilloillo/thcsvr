 
--秘封「天空的格林尼治」
function c28039.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_CHAIN_UNIQUE+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_DECK)
	e1:SetCondition(c28039.descon)
	e1:SetCost(c28039.descost)
	e1:SetTarget(c28039.destg)
	e1:SetOperation(c28039.desop)
	c:RegisterEffect(e1)
	if not c28039.global_check then
		c28039.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c28039.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c28039.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
function c28039.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if not tc:IsSetCard(0x211) then
			c28039[tc:GetSummonPlayer()]=false
		end
		tc=eg:GetNext()
	end
end
function c28039.clear(e,tp,eg,ep,ev,re,r,rp)
	c28039[0]=true
	c28039[1]=true
end
function c28039.descon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():GetControler()==tp and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x211) and Duel.GetTurnPlayer()==tp
end
function c28039.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c28039[tp] and Duel.GetFlagEffect(tp,28039)==0 and e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	Duel.RegisterFlagEffect(tp,28039,RESET_PHASE+PHASE_END,0,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c28039.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c28039.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x211)
end
function c28039.filter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c28039.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c28039.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c28039.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c28039.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c28039.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
