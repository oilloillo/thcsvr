--烧不死的人类✿藤原妹红
function c21091.initial_effect(c)
	--recover?
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21091,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCondition(c21091.reccon)
	e1:SetTarget(c21091.rectg)
	e1:SetOperation(c21091.recop)
	c:RegisterEffect(e1)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(21091,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,21091+EFFECT_FLAG_OATH)
	e4:SetCondition(c21091.condition)
	e4:SetCost(c21091.hspcost)
	e4:SetTarget(c21091.hsptg)
	e4:SetOperation(c21091.hspop)
	c:RegisterEffect(e4)
end
function c21091.reccon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local t=Duel.GetAttackTarget()
	if ev==1 then t=Duel.GetAttacker() end
	if not c:IsRelateToBattle() or c:IsFacedown() then return false end
	e:SetLabel(t:GetLevel()*200)
	return t:GetLocation()==LOCATION_GRAVE and t:IsType(TYPE_MONSTER)
end
function c21091.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(3)
	Duel.SetTargetParam(e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,3,e:GetLabel())
end
function c21091.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(tp,d,REASON_EFFECT)
	Duel.Damage(1-tp,d,REASON_EFFECT)
	Duel.RDComplete()
end
function c21091.filter(c)
	return not (c:IsFaceup() and c:IsSetCard(0x137))
end
function c21091.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c21091.filter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0
end
function c21091.hspcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local cost=math.floor(Duel.GetLP(tp)/2)
	Duel.PayLPCost(tp,cost)
end
function c21091.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and e:GetHandler():IsReason(REASON_EFFECT+REASON_BATTLE) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c21091.hspop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		if tc:IsFaceup() then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e1:SetValue(tc:GetAttack()/2)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
			e2:SetValue(tc:GetDefense()/2)
			tc:RegisterEffect(e2)
		end
	end
end
