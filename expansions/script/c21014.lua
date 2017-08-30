 
--铃仙·优昙华院·稻叶
function c21014.initial_effect(c)
	--summon with no tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21014,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c21014.ntcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetOperation(c21014.atkop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21014,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(c21014.destg)
	e3:SetOperation(c21014.desop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
function c21014.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x256)
end
function c21014.ntcon(e,c)
	if c==nil then return true end
	return c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c21014.cfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c21014.atkop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c21014.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function c21014.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c21014.filter(c)
	return c:IsFacedown() and c:IsDestructable()
end
function c21014.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and c21014.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c21014.filter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c21014.filter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c21014.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
