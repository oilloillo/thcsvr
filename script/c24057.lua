--细网「犍陀多绳索」
function c24057.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c24057.cost)
	e1:SetTarget(c24057.target)
	e1:SetOperation(c24057.activate)
	c:RegisterEffect(e1)
end
function c24057.filter(c)
	return math.abs(c:GetAttack()-c:GetDefence())==200 or math.abs(c:GetAttack()-c:GetDefence())==2000
end
function c24057.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,c24057.filter,1,nil) end
	local g=Duel.SelectReleaseGroupEx(tp,c24057.filter,1,1,nil)
	e:SetLabelObject(g:GetFirst())
	Duel.Release(g,REASON_COST)
end
function c24057.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	local seq=e:GetHandler():GetSequence()
	if Duel.GetFieldCard(tp,LOCATION_MZONE,seq) and Duel.GetFieldCard(tp,LOCATION_SZONE,seq)
		and Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-seq) and Duel.GetFieldCard(1-tp,LOCATION_SZONE,4-seq) then
		local g=Group.CreateGroup()
		g:AddCard(Duel.GetFieldCard(tp,LOCATION_MZONE,seq))
		g:AddCard(Duel.GetFieldCard(tp,LOCATION_SZONE,seq))
		g:AddCard(Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-seq))
		g:AddCard(Duel.GetFieldCard(1-tp,LOCATION_SZONE,4-seq))
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	end
end
function c24057.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_SKIP_DP)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN)
	Duel.RegisterEffect(e1,tp)
	local rt=e:GetLabelObject()
	if rt:IsCode(24004) or rt:IsCode(24044) or rt:IsType(TYPE_TOKEN) then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetReset(RESET_PHASE+PHASE_END)
		e2:SetTargetRange(0,1)
		Duel.RegisterEffect(e2,tp)
	end
	local seq=e:GetHandler():GetSequence()
	if Duel.GetFieldCard(tp,LOCATION_MZONE,seq) and Duel.GetFieldCard(tp,LOCATION_SZONE,seq)
		and Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-seq) and Duel.GetFieldCard(1-tp,LOCATION_SZONE,4-seq) then
		local g=Group.CreateGroup()
		local tc=Duel.GetFieldCard(tp,LOCATION_MZONE,seq)
		if tc then g:AddCard(tc) end
		tc=Duel.GetFieldCard(tp,LOCATION_SZONE,seq)
		if tc then g:AddCard(tc) end
		tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-seq)
		if tc then g:AddCard(tc) end
		tc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,4-seq)
		if tc then g:AddCard(tc) end
		Duel.Destroy(g,REASON_EFFECT)
	end
end
